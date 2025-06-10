final String createProfileMutation = """
  mutation CreateProfile(
    bio: String!,
    location: String!,
    phone: String!,
    email: String!,
    profileImage: Upload!
  ) {
    createProfile(
      bio: bio,
      location: location,
      phone: phone,
      email: email,
      profileImage: profileImage
    ) {
      profile {
        bio
        profileUrl
      }
    }
  }
""";
