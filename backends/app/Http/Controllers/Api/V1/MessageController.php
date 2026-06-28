<?php

namespace App\Http\Controllers\Api\V1;

use App\Events\MessageSent;
use App\Http\Controllers\Controller;
use App\Http\Resources\Api\V1\MessageResource;
use App\Models\Group;
use App\Models\Message;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class MessageController extends Controller
{
    /** Return the last 50 messages for a group. */
    public function index(Request $request, Group $group): JsonResponse
    {
        abort_unless($group->isMember($request->user()->id), 403);

        $messages = $group->messages()
            ->with('sender')
            ->latest()
            ->limit(50)
            ->get()
            ->reverse()
            ->values();

        return response()->json(['messages' => MessageResource::collection($messages)]);
    }

    /** Send a message and broadcast it in real time. */
    public function store(Request $request, Group $group): JsonResponse
    {
        abort_unless($group->isMember($request->user()->id), 403);

        $request->validate(['content' => ['required', 'string', 'max:2000']]);

        $message = Message::create([
            'group_id' => $group->id,
            'user_id' => $request->user()->id,
            'content' => $request->content,
        ]);

        $message->load('sender');

        // Broadcast to all group members in real time via Reverb
        broadcast(new MessageSent($message))->toOthers();

        return response()->json(
            ['message' => new MessageResource($message)],
            201
        );
    }
}
