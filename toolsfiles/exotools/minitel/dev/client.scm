(use-modules (ice-9 rdelim))
(let ((s (socket PF_INET SOCK_STREAM 0)))
  (connect s AF_INET (inet-pton AF_INET "127.0.0.1") 5000)
  (display "fuck" s)

  (do ((line (read-line s) (read-line s)))
      ((eof-object? line))
    (display line)
    (newline)))
