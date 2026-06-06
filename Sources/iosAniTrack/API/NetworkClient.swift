import Foundation

let API_URL = "https://graphql.anilist.co"

func makeGraphQLRequest(query: String, variables: [String: Any] = [:]) async throws -> [String: Any] {
    guard let url = URL(string: API_URL) else {
        throw URLError(.badURL)
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("Bearer \(UserDefaults.standard.string(forKey: "accessToken") ?? "")", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    
    let body: [String: Any] = [
        "query": query,
        "variables": variables
    ]
    
    request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
    
    let (data, response) = try await URLSession.shared.data(for: request)

    guard let httpResponse = response as? HTTPURLResponse else {
        throw URLError(.badServerResponse)
    }

    if httpResponse.statusCode != 200 {
        let responseText = String(data: data, encoding: .utf8) ?? ""
        let message = responseText.isEmpty ? "HTTP \(httpResponse.statusCode)" : "HTTP \(httpResponse.statusCode): \(responseText)"
        throw NSError(domain: "HTTP", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: message])
    }

    guard let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
        throw URLError(.cannotParseResponse)
    }
    
    return jsonObject
}

func fetchViewerData() async throws -> [String: Any] {
    let query = """
    query {
        Viewer {
            id
            name
            about
            avatar {
                large
            }
            bannerImage
        }
    }
    """
    
    let result = try await makeGraphQLRequest(query: query)
    
    if let errors = result["errors"] as? [[String: Any]], !errors.isEmpty {
        throw NSError(domain: "GraphQL", code: 1, userInfo: [NSLocalizedDescriptionKey: errors.map { $0["message"] as? String ?? "Unknown error" }.joined(separator: ", ")])
    }
    
    guard let data = result["data"] as? [String: Any], let viewer = data["Viewer"] as? [String: Any] else {
        throw URLError(.cannotParseResponse)
    }
    
    return viewer
}