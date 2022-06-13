<?php
$to = "your@email.com";
$subject = "Testing";
$content = "Hello World";
$message = "<html><head><title>".$subject."</title></head><body>".$content."</body></html>";

// To send HTML mail, the Content-type header must be set
$headers[] = 'MIME-Version: 1.0';
$headers[] = 'Content-type: text/html; charset=iso-8859-1';
// Additional headers
$headers[] = 'To: Testing <'.$to.'>';
$headers[] = 'From: noreply <noreply@mail.com>';

$result = mail($to, $subject, $message, implode("\r\n", $headers));

echo $result ? "Email sent"."\r\n" : "Fail for some reason"."\r\n";