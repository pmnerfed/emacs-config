;; -*- no-byte-compile: t; -*-

;; [[file:~/.config/doom/config.org::*Prettification][Prettification:1]]
(package! prettify-utils ; simplify messing with prettify-mode
  :recipe (:host github :repo "Ilazki/prettify-utils.el") :pin "8b783d316c23bffdf2b9e6f52635482c4812ee43")
;; Prettification:1 ends here

;; [[file:~/.config/doom/config.org::*Window management][Window management:1]]
(package! rotate :pin "091b5ac4fc310773253efb317e3dbe8e46959ba6")
;; Window management:1 ends here

;; [[file:~/.config/doom/config.org::*Fun][Fun:1]]
(package! xkcd :pin "66e928706fd660cfdab204c98a347b49c4267bdf")
;; Fun:1 ends here

;; [[file:~/.config/doom/config.org::*Fun][Fun:2]]
(package! selectric-mode :pin "bb9e66678f34e9bc23624ff6292cf5e7857e8e5f")
;; Fun:2 ends here

;; [[file:~/.config/doom/config.org::*Fun][Fun:3]]
(package! wttrin :recipe (:local-repo "lisp" :no-byte-compile t))
;; Fun:3 ends here

;; [[file:~/.config/doom/config.org::*Fun][Fun:4]]
(package! spray :pin "00638bc916227f2f961013543d10e85a43a32e29")
;; Fun:4 ends here

;; [[file:~/.config/doom/config.org::*Fun][Fun:5]]
(package! theme-magic :pin "844c4311bd26ebafd4b6a1d72ddcc65d87f074e3")
;; Fun:5 ends here

;; [[file:~/.config/doom/config.org::*Fun][Fun:6]]
(package! elcord :pin "94b0afb9bac32fa72354517347646166d6bec986")
;; Fun:6 ends here

;; [[file:~/.config/doom/config.org::*Flyspell-lazy][Flyspell-lazy:1]]
(package! flyspell-lazy :pin "3ebf68cc9eb10c972a2de8d7861cbabbbce69570")
;; Flyspell-lazy:1 ends here

;; [[file:~/.config/doom/config.org::*CalcTeX][CalcTeX:1]]
(package! calctex :recipe (:host github :repo "johnbcoughlin/calctex"
                                 :files ("*.el")) :pin "08273d4216ac6cfa6030dfc0ea4bdeed0429e653")
;; CalcTeX:1 ends here

;; [[file:~/.config/doom/config.org::*ESS][ESS:1]]
(package! ess-view :pin "d4e5a340b7bcc58c434867b97923094bd0680283")
;; ESS:1 ends here

;; [[file:~/.config/doom/config.org::*Magit Delta][Magit Delta:1]]
;; (package! magit-delta :recipe (:host github :repo "dandavison/magit-delta") :pin "0c7d8b2359")
;; Magit Delta:1 ends here

;; [[file:~/.config/doom/config.org::*Info colours][Info colours:1]]
(package! info-colors :pin "47ee73cc19b1049eef32c9f3e264ea7ef2aaf8a5")
;; Info colours:1 ends here

;; [[file:~/.config/doom/config.org::*Email][Email:1]]
(package! org-msg)
;; Email:1 ends here

;; [[file:~/.config/doom/config.org::*Email][Email:2]]
(package! mu4e-alert)
;; Email:2 ends here

;; [[file:~/.config/doom/config.org::*LaTeX][LaTeX:1]]
(package! evil-tex :recipe (:host github :repo "itai33/evil-tex")
                            :pin "9365aa33a0e73d8015cd93f039d2ba91dbe52cad")
;; LaTeX:1 ends here

;; [[file:~/.config/doom/config.org::*Improve agenda/capture][Improve agenda/capture:1]]
(package! org-super-agenda :pin "dd0d104c269fab9ebe5af7009bc1dd2a3a8f3c12")
;; Improve agenda/capture:1 ends here

;; [[file:~/.config/doom/config.org::*Improve agenda/capture][Improve agenda/capture:2]]
(package! doct
  :recipe (:host github :repo "progfolio/doct")
  :pin "1bcec209e12200c9b93b0d95f61b964b5de4439c")
;; Improve agenda/capture:2 ends here

;; [[file:~/.config/doom/config.org::*Visuals][Visuals:1]]
(package! org-pretty-table-mode
  :recipe (:host github :repo "Fuco1/org-pretty-table") :pin "88380f865a79bba49e4f501b7fe73a7bfb03bd1a")
;; Visuals:1 ends here

;; [[file:~/.config/doom/config.org::*Visuals][Visuals:2]]
(package! org-fragtog :pin "8eca8084cc025c43ce2677b38ed4919218dd9ad9")
;; Visuals:2 ends here

;; [[file:~/.config/doom/config.org::*Visuals][Visuals:3]]
(package! org-pretty-tags :pin "40fd72f3e701e31813f383fb429d30bb88cee769")
;; Visuals:3 ends here

;; [[file:~/.config/doom/config.org::*Extra functionality][Extra functionality:1]]
(package! ox-gfm :pin "99f93011b069e02b37c9660b8fcb45dab086a07f")
;; Extra functionality:1 ends here

;; [[file:~/.config/doom/config.org::*Extra functionality][Extra functionality:2]]
(package! org-ref :pin "4ce80644377f2369efb475bd58a57cf6950d8c41")
;; Extra functionality:2 ends here

;; [[file:~/.config/doom/config.org::*Extra functionality][Extra functionality:3]]
(package! org-graph-view :recipe (:host github :repo "alphapapa/org-graph-view") :pin "13314338d70d2c19511efccc491bed3ca0758170")
;; Extra functionality:3 ends here

;; [[file:~/.config/doom/config.org::*Extra functionality][Extra functionality:4]]
(package! org-chef :pin "1dd73fd3db0e9382fa34d3b48c8ec608e65f3bdc")
;; Extra functionality:4 ends here

;; [[file:~/.config/doom/config.org::*Extra functionality][Extra functionality:5]]
(package! org-plot :recipe (:local-repo "lisp" :no-byte-compile t))
;; Extra functionality:5 ends here

;; [[file:~/.config/doom/config.org::*Systemd][Systemd:1]]
(package! systemd :pin "51c148e09a129ddf33d95276aa0e89d4ef6f8dd2")
;; Systemd:1 ends here
