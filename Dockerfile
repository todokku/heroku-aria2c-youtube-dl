FROM heroku/heroku:18

RUN apt-get update && apt-get install -y ffmpeg

WORKDIR /root

COPY . .

RUN curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /bin/youtube-dl
RUN curl -sSL https://github.com/cxjava/j2ee/releases/download/v0.0.2/simhei.ttf -o /root/simhei.ttf
RUN curl -sSL $(curl -sSL https://api.github.com/repos/cxjava/goreman/releases | grep browser_download_url | grep 'linux_amd64' | head -n 1 | cut -d '"' -f 4) | zcat > /bin/goreman
RUN curl -sSL $(curl -sSL https://api.github.com/repos/cxjava/heroku-aria2c-youtube-dl/releases | grep browser_download_url | grep 'linux_amd64' | head -n 1 | cut -d '"' -f 4) | zcat > /bin/heroku-aria2c-youtube-dl

RUN chmod +x /bin/goreman /root/run.sh /bin/heroku-aria2c-youtube-dl
RUN chmod a+rx /bin/youtube-dl

RUN useradd -m heroku
USER heroku
EXPOSE 5000
COPY Procfile Procfile
CMD goreman -b=$PORT start
