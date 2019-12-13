# substring_highlight

Highlight Flutter text at the character-level.  Designed for case-insensitive search-term highlighting, a single search term sub-string is highlighted (perhaps multiple times) within a longer string.    Inspired by the existing Flutter package "highlight_text," but supports sub-word character matches (e.g., 't' in 'Peter').  Limits: Only supports a single search term and does not support clickable highlighted sub-strings.

The substrings being searched for highlighting don't have to match at the beginning of the longer strings (can be anywhere inside, case-insensitive).


## Default Styling Example
### Code:
As an example, the following code snippet uses this package to highlight matching characters in each search result:  
```
import 'package:substring_highlight/substring_highlight.dart';

...

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: SubstringHighlight(
        text: dropDownItem,     // search result string from database or something
        term: searchTerm,       // user typed "et"
      ),
    );
  }
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
  Widget build(BuildContext context) {
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
  }
```
### Output:
![Screenshot](example2.png)