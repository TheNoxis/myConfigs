augroup filetypedetect
	autocmd BufRead,BufNewFile *mutt-*			set filetype=mail
	autocmd BufRead,BufNewFile haproxy*			set filetype=haproxy
	autocmd BufRead,BufNewFile Dockerfile*		set filetype=dockerfile
	autocmd BufRead,BufNewFile *.gradle			set filetype=groovy
	autocmd BufRead,BufNewFile *.py				set filetype=python
	autocmd BufRead,BufNewFile Makefile*		set filetype=make
	" Service = systemd
	autocmd BufRead,BufNewFile *.service		set filetype=gitconfig
	" Pour ansible:
	autocmd BufRead,BufNewFile hosts			set ft=conf
augroup END
