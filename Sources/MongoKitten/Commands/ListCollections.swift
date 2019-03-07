struct ListCollections: AdministrativeMongoDBCommand {
    typealias Reply = CursorReply
    
    var namespace: Namespace {
        return listCollections.namespace
    }
    
    var isRetryableWrite: Bool { return false }
    
    let listCollections: AdministrativeNamespace
    var filter: Document?
    
    init(inDatabase database: String) {
        self.listCollections = AdministrativeNamespace(namespace: Namespace(to: "$cmd", inDatabase: database))
    }
}

struct CollectionDescription: Codable {
    let name: String
}
