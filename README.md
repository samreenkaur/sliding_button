## 🚀 Sliding Button

A customizable, animated slide-to-act button for Flutter. Slide to trigger an action, and reset to use again — just like swipe-to-unlock or slide-to-submit UIs.


---

## ✨ Features

- 🎯 Slide-to-complete functionality
- 🔁 Optional auto-reset or manual reset via code
- 🎨 Customizable text, colors, size, and background
- 🧩 Easy to integrate using a `GlobalKey`
- ⚙️ Smooth animations and cancel/complete gestures

---

## 📦 Installation

Add this to your `pubspec.yaml`:

```
dependencies:
  sliding_button:
    git:
      url: https://github.com/samreenkaur/sliding_button.git
```  

## 🚀 Usage

```
import 'package:sliding_button/sliding_button.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final GlobalKey<SlideActionButtonState> _sliderKey = GlobalKey();

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Sliding Button Example')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SlideActionButton(
                key: _sliderKey,
                onSlideComplete: () {
                  print('✅ Action Completed!');
                },
                autoReset: false, // set to true for auto reset
                text: "Slide to Unlock",
                textStyle: const TextStyle(fontSize: 16, color: Colors.white),
                sliderColor: Colors.green,
                backgroundColor: Colors.grey.shade800,
                height: 60,
                borderRadius: 30,
              ),
              const SizedBox(height: 20),
              ElevatedButton( // use in case of manual reset otherwise use autoReset: true
                onPressed: () {
                  _sliderKey.currentState?.reset(); // manually reset
                },
                child: const Text("Reset"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

## ⚙️ Parameters

Property        	Type	            Description
onSlideComplete	    VoidCallback	    Called once when slide is completed successfully
autoReset	        bool	            Whether the button should reset automatically
text	            String	            Text shown inside the sliding track
textStyle	        TextStyle?	        Customize text appearance
height	            double?	            Height of the button
width	            double?	            Width of the button (default: full width)
backgroundColor	    Color?	            Background color of the track
sliderColor	        Color?	            Color of the sliding button
borderRadius	    double?	            Border radius for rounded corners


## 🔁 Resetting the Button

If autoReset is false, you can reset the slider manually using a GlobalKey.

```
final GlobalKey<SlideActionButtonState> _sliderKey = GlobalKey();

_sliderKey.currentState?.reset();

```

## 🛠️ Contributing

Found an issue or want to add a feature? Feel free to open a PR or issue on GitHub.

## 📄 License

This project is licensed under the MIT License. See the LICENSE file for details.

Made by @samreenkaur


```
Let me know if you want:
- A GIF/demo image to include in the README.
- To auto-publish this to [pub.dev](https://pub.dev/).
- A logo/badge design for the package.
```