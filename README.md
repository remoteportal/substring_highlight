# substring_highlight

Highlight text at the letter-level.  Designed for search-term highlighting, a single search sub-string is highlighted (perhaps multiple tiimes) within a longer string.    Like the existing package &quot;highlight_text,&quot; but highlights sub-word character matches (&#x27;t&#x27; in &#x27;Peter&#x27;), and only supports a single search term.   Does NOT currently support clickable highlights.

## Example
### Code
As an example, the following build code uses this package to highlight what is matched in the search results:  
`
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: SubstringHighlight(
        text: dropDownItem,
        term: searchTerm,       // 'a'
      ),
    );
  }
`
### Output
![Screenshot](example.png)

