# Rules Testing


### Explanation:  
- tag1: not in notay
- tag2: in notary
- sha1: wrong sha
- sha2: sha contained in notary


### images:
- latest: `redis:latest`
- tag1:   `docker.io/dgeiger/alpine:3`
- tag2:   `docker.io/dgeiger/nginx:1.15`
- sha1:   `docker.io/dgeiger/alpine@sha256:5555555`
- sha2:   `docker.io/dgeiger/nginx@sha256:e770165fef9e36b990882a4083d8ccf5e29e469a8609bb6b2e3b47d9510e2c8d`


### Validation
| scenario                   | validating response          | yaml                            |
| -------------------------  | ---------------------------  | --------------------------------|
| pod-latest                 | deny (error 1 image)         | 1-pod-latest                    |
| pod-tag                    | deny (error 1 image)         | 3-pod-tag2                      |
| -------------------------  | ---------------------------  | --------------------------------|
| pod-sha1                   | deny (error 1 image)         | 4-pod-sha1                      |
| pod-sha2                   | allow                        | 5-pod-sha2                      |
| -------------------------  | ---------------------------  | --------------------------------|
| pod-latest-tag             | deny (error 2 images)        | 7-pod-latest-tag2               |
| pod-latest-sha1            | deny (error 2 images)        | 8-pod-latest-sha1               |
| pod-latest-sha2            | deny (error 1 image)         | 9-pod-latest-sha2               |
| pod-tag-sha1               | deny (error 2 images)        | 12-pod-tag2-sha1                |
| pod-tag-sha2               | deny (error 1 image)         | 13-pod-tag2-sha2                |
| -------------------------  | ---------------------------  | --------------------------------|
| pod-tag1-tag1              | deny (error 2 images)        | 14-pod-tag1-tag1                |
| pod-tag1-tag2              | deny (error 2 images)        | 15-pod-tag1-tag2                |
| pod-tag2-tag2              | deny (error 2 images)        | 16-pod-tag2-tag2                |
| -------------------------  | ---------------------------  | --------------------------------|
| pod-sha1-sha1              | deny (error 2 images)        | 17-pod-sha1-sha1                |   only one request on wrapper
| pod-sha1-sha2              | deny (error 1 image)         | 18-pod-sha1-sha2                |
| pod-sha2-sha2              | allow                        | 19-pod-sha2-sha2                |
| -------------------------  | ---------------------------  | --------------------------------|
| pod-latest-tag-sha1        | deny (error 3 images)        | 22-pod-latest-tag2-sha1         |
| pod-latest-tag-sha2        | deny (error 2 images)        | 23-pod-latest-tag2-sha2         |
| -------------------------  | ---------------------------  | --------------------------------|
| -------------------------  | ---------------------------  | --------------------------------|
| deploy-latest              | deny (error 1 image)         | 1-deploy-latest                 |
| deploy-tag                 | deny (error 1 image)         | 3-deploy-tag2                   |
| -------------------------  | ---------------------------  | --------------------------------|
| deploy-sha1                | deny (error 1 image)         | 4-deploy-sha1                   |
| deploy-sha2                | allow                        | 5-deploy-sha2                   |
| -------------------------  | ---------------------------  | --------------------------------|
| deploy-latest-tag          | deny (error 2 images)        | 7-deploy-latest-tag2            |
| deploy-latest-sha1         | deny (error 2 images)        | 8-deploy-latest-sha1            |
| deploy-latest-sha2         | deny (error 1 image)         | 9-deploy-latest-sha2            |
| -------------------------  | ---------------------------  | --------------------------------|
| deploy-tag-sha1            | deny (error 2 images)        | 12-deploy-tag2-sha1             |
| deploy-tag-sha2            | deny (error 1 image)         | 13-deploy-tag2-sha2             |
| -------------------------  | ---------------------------  | --------------------------------|
| deploy-tag1-tag1           | allow                        | 14-deploy-tag1-tag1             |
| deploy-tag1-tag2           | allow (mutate 1 image)       | 15-deploy-tag1-tag2             |
| deploy-tag2-tag2           | allow (mutate 2 images)      | 16-deploy-tag2-tag2             |
| -------------------------  | ---------------------------  | --------------------------------|
| deploy-sha1-sha1           | deny (error 2 images)        | 17-deploy-sha1-sha1             |   only one request on wrapper
| deploy-sha1-sha2           | deny (error 1 image)         | 18-deploy-sha1-sha2             |
| deploy-sha2-sha2           | allow                        | 19-deploy-sha2-sha2             |
| -------------------------  | ---------------------------  | --------------------------------|
| deploy-latest-tag-sha1     | deny (error 3 images)        | 22-deploy-latest-tag2-sha1      |
| deploy-latest-tag-sha2     | deny (error 2 images)        | 23-deploy-latest-tag2-sha2      |
| -------------------------  | ---------------------------  | --------------------------------|


### Mutation/Validation
| scenario                   | mutating response            | yaml                            | validating response |
| -------------------------  | ---------------------------  | ------------------------------  | --------------------|
| pod-latest                 | allow                        | 1-pod-latest                    | deny                |
| pod-tag1                   | allow                        | 2-pod-tag1                      | deny                |
| pod-tag2                   | allow (mutate)               | 3-pod-tag2                      | allow               |
| -------------------------  | ---------------------------  | ------------------------------  | --------------------|
| pod-sha1                   | allow                        | 4-pod-sha1                      | deny                |
| pod-sha2                   | allow                        | 5-pod-sha2                      | allow               |
| -------------------------  | ---------------------------  | ------------------------------  | --------------------|
| pod-latest-tag1            | allow                        | 6-pod-latest-tag1               | deny                |
| pod-latest-tag2            | allow (mutate 1 image)       | 7-pod-latest-tag2               | deny                |
| pod-latest-sha1            | allow                        | 8-pod-latest-sha1               | deny                |
| pod-latest-sha2            | allow                        | 9-pod-latest-sha2               | deny                |
| -------------------------  | ---------------------------  | ------------------------------  | --------------------|
| pod-tag1-sha1              | allow                        | 10-pod-tag1-sha1                | deny                |
| pod-tag1-sha2              | allow                        | 11-pod-tag1-sha2                | deny                |
| pod-tag2-sha1              | allow (mutate 1 image)       | 12-pod-tag2-sha1                | deny                |
| pod-tag2-sha2              | allow (mutate 1 image)       | 13-pod-tag2-sha2                | allow               |
| -------------------------  | ---------------------------  | ------------------------------  | --------------------|
| pod-tag1-tag1              | allow                        | 14-pod-tag1-tag1                | deny                |
| pod-tag1-tag2              | allow (mutate 1 image)       | 15-pod-tag1-tag2                | deny                |
| pod-tag2-tag2              | allow (mutate 2 images)      | 16-pod-tag2-tag2                | allow               |
| -------------------------  | ---------------------------  | ------------------------------  | --------------------|
| pod-sha1-sha1              | allow                        | 17-pod-sha1-sha1                | deny                |
| pod-sha1-sha2              | allow                        | 18-pod-sha1-sha2                | deny                |
| pod-sha2-sha2              | allow                        | 19-pod-sha2-sha2                | allow               |
| -------------------------  | ---------------------------  | ------------------------------  | --------------------|
| pod-latest-tag1-sha1       | allow                        | 20-pod-latest-tag1-sha1         | deny                |
| pod-latest-tag1-sha2       | allow                        | 21-pod-latest-tag1-sha2         | deny                |
| pod-latest-tag2-sha1       | allow (mutate 1 image)       | 22-pod-latest-tag2-sha1         | deny                |
| pod-latest-tag2-sha2       | allow (mutate 1 image)       | 23-pod-latest-tag2-sha2         | deny                |
| -------------------------  | ---------------------------  | ------------------------------  | --------------------|
| -------------------------  | ---------------------------  | ------------------------------  | --------------------|
| deploy-latest              | allow                        | 1-deploy-latest                 | deny                |
| deploy-tag1                | allow                        | 2-deploy-tag1                   | deny                |
| deploy-tag2                | allow (mutate 1 image)       | 3-deploy-tag2                   | allow               |
| -------------------------  | ---------------------------  | ------------------------------  | --------------------|
| deploy-sha1                | allow                        | 4-deploy-sha1                   | deny                |
| deploy-sha2                | allow                        | 5-deploy-sha2                   | allow               |
| -------------------------  | ---------------------------  | ------------------------------  | --------------------|
| deploy-latest-tag1         | allow                        | 6-deploy-latest-tag1            | deny                |
| deploy-latest-tag2         | allow (mutate 1 image)       | 7-deploy-latest-tag2            | deny                |
| deploy-latest-sha1         | allow                        | 8-deploy-latest-sha1            | deny                |
| deploy-latest-sha2         | allow                        | 9-deploy-latest-sha2            | deny                |
| -------------------------  | ---------------------------  | ------------------------------  | --------------------|
| deploy-tag1-sha1           | allow                        | 10-deploy-tag1-sha1             | deny                |
| deploy-tag1-sha2           | allow                        | 11-deploy-tag1-sha2             | deny                |
| deploy-tag2-sha1           | allow (mutate 1 image)       | 12-deploy-tag2-sha1             | deny                |
| deploy-tag2-sha2           | allow (mutate 1 image)       | 13-deploy-tag2-sha2             | allow               |
| -------------------------  | ---------------------------  | ------------------------------  | --------------------|
| deploy-tag1-tag1           | allow                        | 14-deploy-tag1-tag1             | deny                |
| deploy-tag1-tag2           | allow (mutate 1 image)       | 15-deploy-tag1-tag2             | deny                |
| deploy-tag2-tag2           | allow (mutate 2 images)      | 16-deploy-tag2-tag2             | allow               |
| -------------------------  | ---------------------------  | ------------------------------  | --------------------|
| deploy-sha1-sha1           | allow                        | 17-deploy-sha1-sha1             | deny                |
| deploy-sha1-sha2           | allow                        | 18-deploy-sha1-sha2             | deny                |
| deploy-sha2-sha2           | allow                        | 19-deploy-sha2-sha2             | allow               |
|--------------------------  | ---------------------------  | ------------------------------  | --------------------|
| deploy-latest-tag1-sha1    | allow                        | 20-deploy-latest-tag1-sha1      | deny                |
| deploy-latest-tag1-sha2    | allow                        | 21-deploy-latest-tag1-sha2      | deny                |
| deploy-latest-tag2-sha1    | allow (mutate 1 image)       | 22-deploy-latest-tag2-sha1      | deny                |
| deploy-latest-tag2-sha2    | allow (mutate 1 image)       | 23-deploy-latest-tag2-sha2      | allow               |
| -------------------------  | ---------------------------  | ------------------------------  | --------------------|

