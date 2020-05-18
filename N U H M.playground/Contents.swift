//#-hidden-code
import UIKit
import PlaygroundSupport
//#-end-hidden-code

/*:
 # Now You Hear Me
 Hello! I'm a college student having two majors: Computer Science and Statistics. One of the most fascinating thing I found among the things I learnt is recursive sequence. Don't be frightened by its name! This playground will definitely give you a better sense of that, besides, you can even make music with recursive sequence!
 
 ## About Recursive Sequence
 Mathematically, a sequence refers to a list of numbers, or terms. Recursive sequence is a special kind of sequence whose term can be conducted from terms before that term. The following 2 things are essential for a deciding a recursive sequence.
 
 - Initial term(s): The first several terms for the sequence. Since there is not enough terms before them for conducting their value, we need to give them explicitly.
 - Recursive Formula: A formula that explicitly defines how to conduct new terms with terms before them.
 
 ## Play with It
 This Playground gives you a fresh way to define and visualize your own recursive sequence. Besides, it plays your sequence terms with piano!
 
 ### Define the Initial Terms
 You can find 2 sliders at the interface. The sliders helps you to pick the initial terms of your sequence in an extremely easy way. Just slide, and pick the first and second initial terms from `0` to `9`.
 
 ### Choose a Recursive Formula
 Sometimes even mathemeticians don't actually like writing formulaes. However, you can easily choose a prototype formulae by simply tapping the arrow button. There are several prototypes for you to choose from.
 
 - __constant__: `x_(i) = x_(i - 1)`. This formula gives new term identically as the previous term. Hummmmm. this sounds plain.
 - __linear__: `x_(i) = x_(i - 1) + (x_(i - 1) - x_(i - 2))`. This formula generates arithmetic progression. Could you play a C scale with this formula?
 - __fibonacci__: `x_(i) = x_(i - 1) + x_(i - 2)`. You are sure to know this name. This formula makes the sequence to grow aggressively. Does its piano nots also sounds aggressive? You will see.
 - __regression__: `x_(i) = x_(i - 1) - x_(i - 2) + 2`. It's a formula I found that makes rather good music, if you try more, you can also find yours.
 - __random__: `x_(i) = randint()`. Why don't simply give the control to the natural world and let it create for you?
 
 Are you feeling like writing your own recursive formula? Here's the chance! You can implement `customizedForward` closure by your self, and choose __customized__ to use your own defined formula. I really hope you find some sequence that makes good music.
 */
customizedForward = { prev_prev_value, prev_value in
    return /*#-editable-code number of repetitions*/prev_value - 2 * prev_prev_value + 5/*#-end-editable-code*/
}
/*:
 > Probably you will find the piano note sounds don't match the sequence term sometimes, this is because we have very limited piano keys, but unlimited natural numbers. If the term is too big or too small to be represented by a piano note, we take modulus to drag it back.
 */


//#-hidden-code
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = SequenceViewController()
//#-end-hidden-code
