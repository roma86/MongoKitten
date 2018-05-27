import NIO

public final class Cursor<Element> {
    typealias Mapping = (Document) -> Element
    
    var id: Int64
    var buffer: [Element]
    var drained: Bool {
        return self.id == 0
    }
    let collection: Collection
    var batchSize = 101
    var mapping: Mapping
    
    fileprivate init(id: Int64, buffer: [Element], collection: Collection, mapping: @escaping Mapping) {
        self.id = id
        self.buffer = buffer
        self.collection = collection
        self.mapping = mapping
    }
    
    func map<T>(_ transform: (Element) throws -> T) -> Cursor<T> {
        unimplemented()
    }
    
    public func forEach(_ body: @escaping (Element) throws -> Void) -> EventLoopFuture<Void> {
        do {
            for element in buffer {
                try body(element)
            }
            
            if drained {
                return self.collection.eventLoop.newSucceededFuture(result: ())
            }
            
            return getMore().then {
                return self.forEach(body)
            }
        } catch {
            return self.collection.eventLoop.newFailedFuture(error: error)
        }
    }
    
    func getMore() -> EventLoopFuture<Void> {
        return GetMore(cursorId: self.id, batchSize: batchSize, on: self.collection)
            .execute(on: self.collection.connection)
            .map { reply -> Void in
                self.id = reply.cursor.id
                self.buffer = reply.cursor.nextBatch.map(self.mapping)
            }
    }
    
}

extension Cursor where Element == Document {
    internal convenience init(_ reply: CursorReply, collection: Collection) throws {
        self.init(
            id: reply.cursor.id,
            buffer: reply.cursor.firstBatch,
            collection: collection
        ) { document in
            return document
        }
    }
}
