; extends

(
    (string_content) @injection.content
    (#match? @injection.content "SELECT|INSERT|CREATE|UPDATE|DELETE|WHERE|FROM|JOIN")
    (#set! injection.language "sql")
) 

