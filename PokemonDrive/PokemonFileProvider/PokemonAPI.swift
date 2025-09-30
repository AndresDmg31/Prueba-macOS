import Foundation

final class PokemonAPI {
    static let shared = PokemonAPI()
    private init() {}

    private let session: URLSession = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.waitsForConnectivity = true
        configuration.timeoutIntervalForRequest = 20
        configuration.httpAdditionalHeaders = ["Accept": "application/json"]
        return URLSession(configuration: configuration)
    }()

    private var appGroupURL: URL? {
        FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.andres.PokemonDrive")
    }

    private var cacheURL: URL? {
        appGroupURL?.appendingPathComponent("pokemon-cache.json")
    }

    struct ListResponse: Decodable {
        struct Entry: Decodable { let name: String }
        let results: [Entry]
    }

    func fetchPokemonList(limit: Int, completion: @escaping (Result<[String], Error>) -> Void) {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=\(limit)") else {
            completion(.failure(NSError(domain: "PokemonAPI", code: -1)))
            return
        }
        session.dataTask(with: url) { data, _, error in
            if let error = error {
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async { completion(.failure(NSError(domain: "PokemonAPI", code: -2))) }
                return
            }
            do {
                let decoded = try JSONDecoder().decode(ListResponse.self, from: data)
                let names = decoded.results.map { $0.name }
                self.writeCache(names: names)
                DispatchQueue.main.async { completion(.success(names)) }
            } catch {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }.resume()
    }

    func cachedPokemonNames() -> [String] {
        guard let url = cacheURL, let data = try? Data(contentsOf: url),
              let names = try? JSONDecoder().decode([String].self, from: data) else { return [] }
        return names
    }

    private func writeCache(names: [String]) {
        guard let url = cacheURL else { return }
        do {
            let data = try JSONEncoder().encode(names)
            try FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true)
            try data.write(to: url, options: .atomic)
        } catch {
            
        }
    }
}



