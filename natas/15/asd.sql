-- SELECT * FROM USERS
UPDATE users SET username = "User2" WHERE username = "user2"

SELECT 
    *
FROM
    USERS
WHERE
    username = ''
        OR (username = 
        (SELECT 
            username
        FROM
            users
        ORDER BY username , password LIMIT 1)
	AND SUBSTRING(username, 1, 1) REGEXP '[0-9]')