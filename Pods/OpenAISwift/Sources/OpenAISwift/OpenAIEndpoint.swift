//
//  Created by Adam Rush - OpenAISwift
//

import Foundation

enum Endpoint {
    case completions
    case edits
    case chat
    case images
    case embeddings
}

extension Endpoint {
    var path: String {
        switch self {
            case .completions:
//                return "/v1/completions"
                return "/openai/deployments/gpt-35-turbo/completions?api-version=2023-03-15-preview"
            case .edits:
//                return "/v1/edits"
                return "/openai/deployments/gpt-35-turbo/edits?api-version=2023-03-15-preview"
            case .chat:
//                return "/v1/chat/completions"
                return "/openai/deployments/gpt-35-turbo/chat/completions?api-version=2023-03-15-preview"
            case .images:
//                return "/v1/images/generations"
                return "/openai/deployments/gpt-35-turbo/images/generations?api-version=2023-03-15-preview"
            case .embeddings:
//            return "/v1/embeddings"
                return "/openai/deployments/gpt-35-turbo/embeddings?api-version=2023-03-15-preview"
        }
    }
    
    var method: String {
        switch self {
            case .completions, .edits, .chat, .images, .embeddings:
            return "POST"
        }
    }
    
    func baseURL() -> String {
        switch self {
            case .completions, .edits, .chat, .images, .embeddings:
//            return "https://api.openai.com"
            return "https://gptformobile.openai.azure.com"
        }
    }
}
