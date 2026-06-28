<?php

namespace App\Mail;

use App\Models\User;
use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Attachment;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;
use Illuminate\Queue\SerializesModels;

class StudentWelcomeMail extends Mailable
{
    use Queueable, SerializesModels;

    public function __construct(
        public readonly User $user,
        public readonly string $invitedBy,
    ) {}

    public function envelope(): Envelope
    {
        return new Envelope(
            subject: 'Welcome to TeamScribe — set up your account',
        );
    }

    public function content(): Content
    {
        return new Content(view: 'emails.student-welcome');
    }

    /** @return array<int, Attachment> */
    public function attachments(): array
    {
        return [];
    }
}
