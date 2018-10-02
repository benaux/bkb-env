(let ((s (socket PF_INET SOCK_STREAM 0)))
  (setsockopt s SOL_SOCKET SO_REUSEADDR 1)
  ;; Specific address?
  ;; (bind s AF_INET (inet-pton AF_INET "127.0.0.1") 2904)
  (bind s AF_INET INADDR_ANY 5000)
  (listen s 5)

  (simple-format #t "Listening for clients in pid: ~S" (getpid))
  (newline)

  (while #t
    (let* ((client-connection (accept s))
           (client-details (cdr client-connection))
           (client (car client-connection)))
      (simple-format #t "Got new client connection: ~S"
                     client-details)
      (newline)
      (simple-format #t "Client address: ~S"
                     (gethostbyaddr
                      (sockaddr:addr client-details)))
      (newline)
      ;; Send back the greeting to the client port
      (display "Hello client\r\n" client)
      (close client))))
