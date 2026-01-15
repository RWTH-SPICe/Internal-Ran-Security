#Use MongoDB image as base
FROM mongo

#Use OUR init.js file in the container
COPY mongodb/init.js /docker-entrypoint-initdb.d/init.js
