const String generalPostQuery = r"""
                        query{
                          posts{
                            id
                            title
                            caption
                            pictureUrl
                            createdAt
                            updatedAt
                            viewers
                            dislikes{
                              id
                              username
                              profilePick
                            }
                            user{
                              id
                              username
                              profilePick
                            }
                          }
                        }
                      """;

const String commentsOfPostQuery = r"""
                        query($id: Int!){
                          comments(id: $id){
                            id
                            body
                            createdAt
                            user{
                              username
                              profilePick
                            }
                          }
                        }
                        """;
