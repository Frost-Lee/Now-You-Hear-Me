//#-hidden-code
import UIKit
import PlaygroundSupport
//#-end-hidden-code

/*:
 # Now You Hear Me
 Hello! I'm a college student having two majors: Computer Science and Statistics. I learn lots of math courses. One of the most fascinating thing in math is sequence. A general formula can be given for most sequence. Oh, you don't need to know that! Just spend some time playing my Playground and give it a try!
 
 Building an user interface that satisfies everyone is tough, thus, I left you the opportunity to choose the color of the background and the value bars!
 */
barColor = /*#-editable-code number of repetitions*/#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)/*#-end-editable-code*/
backgroundColor = /*#-editable-code number of repetitions*/#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)/*#-end-editable-code*/
/*:
 Why not give it a try by pressing the Start button? It's enjoyable.
 */
/*:
 
 ### About the general formula
 Generally speaking, the general formula represents the regular pattern of a sequence, such as the pattern `x_(i) = 1` for constant sequence `[1, 1, 1, 1, ...]` and pattern `x_(i) = x_(i - 1) + 1` for ascending sequence `[1, 2, 3, 4, ...]`.
 
 Here, you can define your own general formula by assigning return value of the closure `forward`, which is used to return the value of the next term of the sequence.

 The parameter `prev_value` represents `x_(i - 1)`, and `prev_prev_value` represents `x_(i - 2)`. Two parameters are provided in case you would like to define more complicated general formula, such as the general formula for Fibonacci sequence: `x_(i) = x_(i - 1) + x_(i - 2)`.
 > You can seek for more probabilities for your sequence, like adding a random term, which would make the sequence a time series, theoretically speaking.
 */
forward = { prev_prev_value, prev_value in
    return /*#-editable-code number of repetitions*/prev_value - prev_prev_value + 2/*#-end-editable-code*/
}
/*:
 
 ### About the initial terms
 The initial can also define the pattern of the sequence. Two sequence might be different even if they have identical general formula, such as the sequence `[1, 3, 5, 7, ...]` and `[2, 4, 6, 8, ...]`, both of which have the general formula `x_(i) = x_(i - 1) + 2`.
 
 The parameter `initialValue_0` and `initialValue_1` represent the first and second initial term of the sequence. You can modify your sequence by modifying the initial values.
 */
initialValue_0 = /*#-editable-code number of repetitions*/0/*#-end-editable-code*/
initialValue_1 = /*#-editable-code number of repetitions*/1/*#-end-editable-code*/
/*:
 
 ### Can you hear it?
 In order to give you a better understanding of the variety of the sequence terms, I used notes to represent the terms of your sequence. The greater the term is, the higher the pitch is. Hey, now your sequence is generating music!
 
 By modifying `timeInterval`, you can control the speed of the music. The greater it is, the slower your music is. To get better experience, I suggest you to set the value between `0.1` and `2`.
 */
timeInterval = /*#-editable-code number of repetitions*/0.2/*#-end-editable-code*/
/*:
 What about the term that is too large? Taking the remainer of the absolute value of the term and the number of notes available is a good solution.
 
 You can also cancel taking the remainer for too large terms. If so, the sound of the corresponding note would be replaced by an alert sound.
 */
useModulus = /*#-editable-code number of repetitions*/true/*#-end-editable-code*/



//#-hidden-code
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = AutoRegressionViewController()
//#-end-hidden-code
