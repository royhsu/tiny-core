import TinyCore

//let observable = Observable<Int>()
//
//let subscription = observable.subscribe { event in
//
//    switch event {
//
//    case let .initial(value): print("The initial value is \(value).")
//
//    case let .changing(currentValue, newValue): print("Changing \(currentValue) with \(newValue).")
//
//    case let .changed(updatedValue, oldValue): print("Changed \(oldValue) to \(updatedValue).")
//
//    }
//
//}
//
//observable.value = nil

import UIKit

class RxUITextView: UITextView, UITextViewDelegate, ObservableProtocol {
    
    private let _observable = Observable<String>()
    
    var value: String? {
        
        get { return _observable.value }
        
        set {
            
            _observable.value = newValue
            
            text = newValue
            
        }
        
    }
    
    override init(
        frame: CGRect,
        textContainer: NSTextContainer?
    ) {
    
        super.init(
            frame: frame,
            textContainer: textContainer
        )
        
        self.delegate = self
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.delegate = self
        
    }
    
    func subscribe(
        with subscriber: @escaping (ObservableEvent<String>) -> Void
    )
    -> ObservableSubscription { return _observable.subscribe(with: subscriber) }
    
    // MARK: UITextViewDelegate
    
    func textViewDidChange(_ textView: UITextView) { value = textView.text }
    
}

let textView = RxUITextView()

let textSubscription = textView.subscribe { event in

    print("RxUITextView: ", event.newValue)

}

textView.value = "Hello"

textView.value = "World"

print("-----")

let observable = AnyObservable(textView)

let sub = observable.subscribe { event in
    
    print("Any:", event.newValue)
    
}

observable.value = "A"

textView.value = "B"
