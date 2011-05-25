# encoding: utf-8
# Author::		Lucas Carlson	 (mailto:lucas@rufy.com)
# Copyright:: Copyright (c) 2005 Lucas Carlson
# License::		LGPL

# These are extensions to the String class to provide convenience
# methods for the Classifier package.
# 
# This class wraps Hash instead of adding methods to String, to avoid
# extending the core class too much.

module SimpleBayes
	
	class WordHash < Hash
		def initialize(source)
			@skip_words = CORPUS_SKIP_WORDS
			populate_with(strip_punctuation(source).split)
			super
		end
		
		private
		
		def populate_with(words)
			words.each do |word|
				word.downcase! if word =~ /[\w|']+/
				if valid?( word )
					self[word] ||= 0
					self[word] += 1
				end
			end
		end
		
		def strip_punctuation(string)
			string.tr(',?.!;:"@#$%^&*()_=+[]{}\|<>/`~-', " ")
		end
		
		def valid?(string)
			string =~ /[^\w|']/ || !@skip_words.include?(string)
		end

		CORPUS_SKIP_WORDS = [
				"a",
				"again",
				"all",
				"along",
				"are",
				"also",
				"an",
				"and",
				"as",
				"at",
				"but",
				"by",
				"came",
				"can",
				"cant",
				"couldnt",
				"did",
				"didn",
				"didnt",
				"do",
				"doesnt",
				"dont",
				"ever",
				"first",
				"from",
				"have",
				"her",
				"here",
				"him",
				"how",
				"i",
				"if",
				"in",
				"into",
				"is",
				"isnt",
				"it",
				"itll",
				"just",
				"last",
				"least",
				"like",
				"most",
				"my",
				"new",
				"no",
				"not",
				"now",
				"of",
				"on",
				"or",
				"should",
				"sinc",
				"so",
				"some",
				"th",
				"than",
				"this",
				"that",
				"the",
				"their",
				"then",
				"those",
				"to",
				"told",
				"too",
				"true",
				"try",
				"until",
				"url",
				"us",
				"were",
				"when",
				"whether",
				"while",
				"with",
				"within",
				"yes",
				"you",
				"youll" ]
	end	
end
