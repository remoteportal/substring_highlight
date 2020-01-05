# substring_highlight

Highlight Flutter text at the character-level.

Designed for case-insensitive search-term highlighting, a single search term sub-string is highlighted (perhaps multiple times) within a longer string.

Inspired by the existing Flutter package "highlight_text," but supports sub-word character matches (e.g., 't' in 'Peter').

Limitations:
1. Only supports a single search term
2. Only case-insensitive matches
3. Highlighted text is not clickable

The substrings being searched for highlighting _don't_ have to match at the *beginning* of the longer strings (can be anywhere inside).

Even space characters will match, but not be highlighted, obviously.

Ancestor MUST have textDirection set (required by internal RichText widget), either through MaterialApp widget or explicitly wrapped by a Directionality widget:
```
Directionality(
    child: SubstringHighlight(text: 'Peter', term: 't'),
    textDirection: TextDirection.ltr)
```


# Pull Requests
Pull requests are welcome!


# Usage
Add a new dependency line to your project/pubspec.yaml file:

```yaml
dependencies:
  ...
  substring_highlight: 0.1.0      # use latest version
```

Don't forget to *flutter pub get*.


# Examples
## Default Styling Example
### Code:
As an example, the following code snippet uses this package to highlight matching characters in each search result:  
```
import 'package:substring_highlight/substring_highlight.dart';

...

  @override
  Widget build(BuildContext context) (
    return Container(
      padding: const EdgeInsets.all(12),
      child: SubstringHighlight(
        text: dropDownItem,     // search result string from database or something
        term: searchTerm,       // user typed "et"
      ),
    );
  )
```
### Output:
![Screenshot](example.png)



## Customized Styling Example
### Code:
This example adds 'textStyle' and 'textStyleHighlight' to change the colors of the text:  
```
import 'package:substring_highlight/substring_highlight.dart';

...

  @override
  Widget build(BuildContext context) (
    return Container(
      padding: const EdgeInsets.all(12),
      child: SubstringHighlight(
        text: dropDownItem,                         // each string needing highlighting
        term: searchTerm,                           // user typed "m4a"        
        textStyle: TextStyle(                       // non-highlight style                       
          color: Colors.grey,
        ),
        textStyleHighlight: TextStyle(              // highlight style
          color: Colors.black,
          decoration: TextDecoration.underline,
        ),        
      ),
    );
  )
```
### Output:
![Screenshot](example2.png)