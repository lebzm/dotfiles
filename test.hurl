GET https://api.thecatapi.com/v1/images/search
Accept: application/json
HTTP 200
[Captures]
url: jsonpath "$[0].url"

GET https://postman-echo.com/get?var={{url}}

GET {{URL}}/health
