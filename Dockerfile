FROM python:latest

# Install Dependencies for tesseract
RUN apt-get update && apt-get install -y \
    g++ \
    autoconf \
    automake \
    libtool \
    autoconf-archive \
    pkg-config \
    libpng-dev \
    libjpeg62-turbo-dev \
    libtiff5-dev zlib1g-dev \
    libleptonica-dev
RUN wget https://github.com/tesseract-ocr/tesseract/archive/4.00.00dev.tar.gz && \
    tar xvf 4.00.00dev.tar.gz && \
    rm -rf 4.00.00dev.tar.gz

WORKDIR tesseract-4.00.00dev/
RUN ./autogen.sh && \
    ./configure && \
    LDFLAGS="-L/usr/local/lib" CFLAGS="-I/usr/local/include" make && \
    make install && \
    ldconfig

RUN pip install pytesseract
RUN pip install pillow
RUN pip install opencv-python

RUN wget https://github.com/tesseract-ocr/tessdata/raw/master/eng.traineddata && \
    mv -v eng.traineddata /usr/local/share/tessdata/

WORKDIR /home

# Cleanup
RUN rm -rf tesseract/4.00.00dev/

RUN tesseract -v

ADD src/ /home/src

CMD [ "python", "src/script.py", "--image", "src/image.png" ]