quiet = "--quiet" %in% commandArgs(FALSE)
formats = commandArgs(TRUE)
travis = !is.na(Sys.getenv('CI', NA))

# provide default formats if necessary
if (length(formats) == 0) formats = c('bookdown::pdf_book', 'bookdown::gitbook')
# render the book to all formats unless they are specified via command-line args
for (fmt in formats) {
  cmd = sprintf("bookdown::render_book('index.Rmd', '%s', quiet = %s)", fmt, quiet)
  res = bookdown:::Rscript(c('-e', shQuote(cmd)))
  if (res != 0) stop('Failed to compile the book to ', fmt)
}
unlink('bookdown_krishna_template.log')

r = '<body onload="window.location = \'https://bookdown.org/krishnakumarg1984\'+location.pathname">'
if (travis) for (f in list.files('_book', '[.]html$', full.names = TRUE)) {
  x = readLines(f)
  if (length(i <- grep('^\\s*<body>\\s*$', x)) == 0) next
  # patch HTML files in gh-pages if built on Travis, to redirect to bookdown.org
  x[i[1]] = r
  writeLines(x, f)
}

redirect = function(from, to) {
  to = paste0('https://bookdown.org/krishnakumarg1984/bookdown_krishna_template/', to)
  writeLines(sprintf(
    '<html><head><meta http-equiv="refresh" content="0; URL=\'%s\'" /></head><body><script>window.location = "%s";</script></html>', to, to
  ), paste0('_book/', from))
}

redirect('r-markdown-components.html', 'rmarkdown-process.html')

if (length(formats) > 1 && Sys.getenv('USER') == 'krishnakumarg1984') {
  bookdown::publish_book(account = 'krishnakumarg1984', server = 'bookdown.org')
}
