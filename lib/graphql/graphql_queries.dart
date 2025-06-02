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
                            }
                            user{
                              id
                              username
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
    }
  }
}
""";
