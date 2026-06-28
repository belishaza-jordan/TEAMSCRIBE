<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Resources\Api\V1\SectionResource;
use App\Models\Activity;
use App\Models\Group;
use App\Models\Section;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class SectionController extends Controller
{
    /** List all sections for a group. */
    public function index(Request $request, Group $group): JsonResponse
    {
        abort_unless($group->isMember($request->user()->id), 403);

        return response()->json([
            'sections' => SectionResource::collection(
                $group->sections()->with('assignee')->get()
            ),
        ]);
    }

    /** Create a new section. */
    public function store(Request $request, Group $group): JsonResponse
    {
        abort_unless($group->isMember($request->user()->id), 403);

        $validated = $request->validate([
            'title' => ['required', 'string', 'max:255'],
            'assigned_to' => ['nullable', 'integer', 'exists:users,id'],
            'due_date' => ['nullable', 'date'],
        ]);

        $section = $group->sections()->create($validated);
        $section->load('assignee');

        // Log an activity so the assigned member sees it in their notifications
        if ($section->assigned_to) {
            Activity::create([
                'group_id' => $group->id,
                'user_id' => $request->user()->id,
                'type' => 'section_assigned',
                'description' => "{$request->user()->name} assigned \"{$section->title}\" to {$section->assignee->name}",
                'metadata' => [
                    'section_id' => $section->id,
                    'section_title' => $section->title,
                    'assigned_to' => $section->assigned_to,
                ],
            ]);
        }

        return response()->json(
            ['section' => new SectionResource($section)],
            201
        );
    }

    /** Update status and/or progress of a section, and log the activity. */
    public function update(Request $request, Group $group, Section $section): JsonResponse
    {
        abort_unless($group->isMember($request->user()->id), 403);
        abort_unless($section->group_id === $group->id, 404);

        $validated = $request->validate([
            'title' => ['sometimes', 'string', 'max:255'],
            'assigned_to' => ['sometimes', 'nullable', 'integer', 'exists:users,id'],
            'status' => ['sometimes', 'in:not_started,in_progress,done'],
            'progress' => ['sometimes', 'integer', 'min:0', 'max:100'],
            'due_date' => ['sometimes', 'nullable', 'date'],
        ]);

        $oldProgress = $section->progress;
        $oldStatus = $section->status;

        $section->update($validated);
        $section->refresh();

        // Log the activity so the progress tab can show what changed
        $this->logActivity($request, $group, $section, $oldProgress, $oldStatus);

        return response()->json(['section' => new SectionResource($section->fresh('assignee'))]);
    }

    private function logActivity(
        Request $request,
        Group $group,
        Section $section,
        int $oldProgress,
        string $oldStatus,
    ): void {
        $user = $request->user();
        $newProgress = $section->progress;
        $newStatus = $section->status;

        if ($newStatus === 'done' && $oldStatus !== 'done') {
            $type = 'section_done';
            $description = "{$user->name} completed \"{$section->title}\"";
        } elseif ($newProgress !== $oldProgress || $newStatus !== $oldStatus) {
            $type = 'section_updated';
            $description = "{$user->name} updated \"{$section->title}\" to {$newProgress}%";
        } else {
            return; // nothing meaningful changed
        }

        Activity::create([
            'group_id' => $group->id,
            'user_id' => $user->id,
            'type' => $type,
            'description' => $description,
            'metadata' => [
                'section_id' => $section->id,
                'section_title' => $section->title,
                'progress' => $newProgress,
                'status' => $newStatus,
            ],
        ]);
    }

    /** Delete a section. */
    public function destroy(Request $request, Group $group, Section $section): JsonResponse
    {
        abort_unless($group->isMember($request->user()->id), 403);
        abort_unless($section->group_id === $group->id, 404);

        $section->delete();

        return response()->json(['message' => 'Section deleted.']);
    }
}
