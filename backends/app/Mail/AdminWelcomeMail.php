<?php

namespace App\Mail;

use App\Models\User;
use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Attachment;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;
use Illuminate\Queue\SerializesModels;

class AdminWelcomeMail extends Mailable
{
    use Queueable, SerializesModels;

    public function __construct(
        public readonly User $user,
        public readonly string $resetUrl,
        public readonly string $invitedBy,
    ) {}

    public function envelope(): Envelope
    {
        return new Envelope(
            subject: "You've been invited to TeamScribe Admin",
        );
    }

    public function content(): Content
    {
        return new Content(view: 'emails.admin-welcome');
    }

    /** @return array<int, Attachment> */
    public function attachments(): array
    {
        return [];
    }
}
