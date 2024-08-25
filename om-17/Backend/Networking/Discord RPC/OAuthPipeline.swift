import OAuthSwift

class DiscordOAuth {
    let oauthswift = OAuth2Swift(
        consumerKey:    "REDACTED",
        consumerSecret: "REDACTED",
        authorizeUrl:   "https://discord.com/api/oauth2/authorize",
        accessTokenUrl: "https://discord.com/api/oauth2/token",
        responseType:   "code"
    )
    
    func authorize(omUser: OMUser) {
        oauthswift.authorize(
            withCallbackURL: "https://server.openmusic.app/discord",
            scope: "rpc",
            state: "DISCORD",
            completionHandler: { response in
                // Save credential.oauthToken for future use
//                switch response {
//                case .success((let credential, let response, let parameters)):
//                    print("CREDENTIAL: \(credential)")
//                case .failure(_):
//                    print("ERROR DOING OAUTH")
//                }
            }
        )
    }
}
