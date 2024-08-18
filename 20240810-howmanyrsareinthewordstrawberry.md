Title: How many Rs are in the word strawberry?
Date: 2024-08-10 04:08:12
Category: Tech
Tags: llm, chatgpt

There's a [viral Mastodon post](https://mastodon.online/@larsmb/112921325458383423)
that demonstrates a supposed deficiency in large language models (LLMs), specifically ChatGPT,
because it apparently can't count the number of letters in the English word
"strawberry".

```
> How many R's are in the word strawberry

ChatGPT: There are two "R's" in the word "strawberry."

> Are you sure?

ChatGPT: Yes, I'm sure. There are two "R's" in the word "strawberry."

[...]

> Count the Rs in the word straw and the word berry separately.

ChatGPT: Sure. Let's break it down:

* The word "straw" has 1 "R."
* The word "berry" has 2 "R's."

So, together they have 3 "R's." But in the combined word "strawberry," there are still only 2 "R's."
```

At first glance, that's a big yikes. (I was able to reproduce the inital
result using ChatGPT 4o.)

But I get annoyed by this kind of post for
two main reasons: 1) if you ask slightly differently, ChatGPT can easily get
this question right, and 2) it's a missed opportunity to explain how LLMs work,
specifically with regards to tokenization.

## Let's try again

Here's the prompt I used with ChatGPT 4o:

```
> Write and then run a Python program to determine how many R's are in the word strawberry

ChatGPT: The word "strawberry" contains 3 occurrences of the letter 'R'. 
```

It's not really well known that ChatGPT has a feature to [execute Python code](https://simonwillison.net/tags/code-interpreter/)
in a sandbox and use the result in answers. 

The Python code it generated was:
```python
# Python program to count the number of 'R's in the word 'strawberry'

word = "strawberry"
count_Rs = word.lower().count('r')  # Convert the word to lowercase and count 'r'
count_Rs
```

The code is pretty simple, and I think we'd all agree that this is
a place where Python code can quite accurately answer this question. Having
the LLM generate the code and execute it nicely sidesteps the underlying issue.

Of course, the problem is you have to prompt it to use Python in the first
place, knowing that this is a subject where an LLM without code execution
would fail. Which brings me to...

## Tokenization

When you provide a prompt for an LLM, it breaks down each word into tokens.
OpenAI provides a [visualization tool](https://platform.openai.com/tokenizer)
for this; you can see that using the GPT-4 tokenizer, the string "strawberry"
is broken down into "str", "aw" and "berry", which get transformed to
numerical values of `[496, 675, 15717]`. Or in other words, the LLM doesn't
have access to individual characters, it just sees the tokens.

In this case, you can try to bypass the tokenizer by using spaces, so each
letter is now its own word and tokenized separately:

```email
> How many r characters are in the letters s t r a w b e r r y

ChatGPT: The word "strawberry" contains 3 instances of the letter "r."
```

Success, though I've had mixed success with approach this in the past.

## Closing thoughts

There are plenty of problems, both technically and ethically, with LLMs and
I don't want to be (or even appear to be) an apologist for them. But I think
it's important that we all understand how LLMs work to actually tackle and
address those problems.
