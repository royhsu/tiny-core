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

print("End")
