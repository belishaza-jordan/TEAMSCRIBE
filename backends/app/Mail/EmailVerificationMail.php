<?php

namespace App\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Attachment;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;
use Illuminate\Queue\SerializesModels;

class EmailVerificationMail extends Mailable
{
    use Queueable, SerializesModels;

    public function __construct(
        public readonly string $otp,
        public readonly string $userName,
    ) {}

    public function envelope(): Envelope
    {
        return new Envelope(
            subject: 'Verify your TeamScribe account',
        );
    }

    public function content(): Content
    {
        return new Content(view: 'emails.email-verification');
    }

    /** @return array<int, Attachment> */
    public function attachments(): array
    {
        return [];
    }
}
