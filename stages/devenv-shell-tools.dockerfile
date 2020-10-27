ARG VERSION=latest
FROM aimmspro/devenv-essentials:$VERSION

#fzf
RUN git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install --no-bash --no-zsh --no-fish

# antigen
RUN curl curl -L git.io/antigen > ~/.antigen.zsh

RUN cat /assets/.zshrc-shell-tools.zsh >> /root/.zshrc

RUN zsh -c 'source ~/.zshrc'
