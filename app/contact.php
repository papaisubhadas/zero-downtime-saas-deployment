<?php
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

// Load PHPMailer (adjust the path to match your structure)
require 'phpmailer/src/Exception.php';
require 'phpmailer/src/PHPMailer.php';
require 'phpmailer/src/SMTP.php';

// Create instance of PHPMailer
$mail = new PHPMailer(true);

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $name    = htmlspecialchars($_POST['name']);
    $email   = htmlspecialchars($_POST['email']);
    $subject = htmlspecialchars($_POST['subject']);
    $message = htmlspecialchars($_POST['message']);

    try {
        // SMTP settings
        $mail->isSMTP();
        $mail->Host       = 'smtp.gmail.com';  // SMTP server (use your provider's SMTP)
        $mail->SMTPAuth   = true;
        $mail->Username   = 'papaisubhadas@gmail.com'; // Your email
        $mail->Password   = 'pruxteqfjecxusla';   // Your email password (use App Password for Gmail)
        $mail->SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS;
        $mail->Port       = 587;

        // Recipients
        $mail->setFrom('papaisubhadas@gmail.com', 'SSD');
        $mail->addAddress('dassubha77@gmail.com', 'Subha'); // Change recipient email
        $mail->addReplyTo($email, $name);

        // Email content
        $mail->isHTML(true);
        $mail->Subject = $subject;
        $mail->Body    = "<strong>Name:</strong> $name <br>
                          <strong>Email:</strong> $email <br>
                          <strong>Message:</strong> <br> $message";

        // Send email
        if ($mail->send()) {
            echo "Your message has been sent. Thank you!";
        } else {
            echo "Error: Message could not be sent.";
        }
    } catch (Exception $e) {
        echo "Error: " . $mail->ErrorInfo;
    }
} else {
    echo "Error: Invalid request.";
}
?>
