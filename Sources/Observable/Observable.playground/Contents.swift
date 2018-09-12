import TinyCore
import UIKit

class RxUITextView: UITextView {
    
    private let _observable = Observable<String>()
    
    override var text: String! {
        
        didSet {
            
            _observable.setValue(
                text,
                options: .muteBroadcaster
            )
            
        }
        
    }
    
}

// MARK: - ObservableProtocol

extension RxUITextView: ObservableProtocol {
    
    var value: String? {
        
        get { return _observable.value }
        
        set {
            
            text = newValue
            
            _observable.value = newValue
            
        }
        
    }
    
    func setValue(
        _ value: String?,
        options: ObservableValueOptions?
    ) {
        
        _observable.setValue(
            value,
            options: options
        )
        
    }
    
    func subscribe(
        with subscriber: @escaping Subscriber
    )
    -> ObservableSubscription { return _observable.subscribe(with: subscriber) }
    
}

let textView = RxUITextView()

let subscription = textView.subscribe { event in

    print("The current value is:", event.currentValue!)

}

textView.value = "Hello"

textView.value = "World"

textView.text = "QQ"

print(textView.value, textView.text)

class Cache: Storage {
    
    var storage: [IndexPath: String] = [:]
    
    subscript(_ indexPath: IndexPath) -> String? {
        
        print("Fetching from the cache...")
        
        return storage[indexPath]
        
    }
    
}

class Disk: Storage {
    
    var storage: [IndexPath: String] = [:]
    
    subscript(_ indexPath: IndexPath) -> String? {
        
        print("Fetching from the disk...")
        
        return storage[indexPath]
        
    }
    
}

protocol Storage {
    
    subscript(_ indexPath: IndexPath) -> String? { get }
    
}

class StorageCoordinator: Storage {
    
    var storages: [Storage] = []
    
    subscript(_ indexPath: IndexPath) -> String? {
        
        for storage in storages {
            
            if let element = storage[indexPath] {
                
                return element
                
            }
            
        }
        
        return nil
        
    }
    
}

let coordinator = StorageCoordinator()

let indexPath = IndexPath(row: 0, section: 0)

let cache = Cache()

cache.storage[indexPath] = "Hi"

let disk = Disk()

disk.storage[indexPath] = "Hi"

coordinator.storages.append(cache)

coordinator.storages.append(disk)

let string = coordinator[indexPath]

print(string)

print("End")
