ft
=============
FT website

## Оптимизация ресурсов

1. Всегда предпочитайте `svg` вместо `png`. 
2. Сжимайте `svg` через https://github.com/svg/svgo.
3. Если все таки пришлось использовать `png`, сжимайте его через https://tinypng.com/.
4. Фоновые и средние/большие картинки обязательно должны быть в `jpg`. Сжимайте через [`mozjpeg`](https://github.com/imagemin/mozjpeg-bin):

    ```bash    
    npm i -g mozjpeg
    mozjpeg -quality 60 -outfile seats.jpg seats.png
    ```

## Copyright

&copy; Decision Mapper. Closed licence.
