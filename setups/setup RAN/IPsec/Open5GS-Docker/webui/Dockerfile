FROM node:19

COPY /open5gs/webui /webui

WORKDIR /webui
RUN npm clean-install && \
    npm run build

COPY webui/wait /wait
RUN chmod +x /wait
    
CMD /wait && npm run dev

EXPOSE 9999