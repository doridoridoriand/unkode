#!/bin/bash
curl $1 --max-time 10 -o /dev/null -w \
"\
%{url_effective}への接続を開始。
名前解決の実行...\n\
名前解決の実行完了@%{time_namelookup}秒経過\n\
対象サーバへの接続...\n\
対象サーバへ接続完了@%{time_connect}秒経過\n\
対象サーバへHTTPリクエスト送信...\n\
対象サーバへHTTPリクエスト送信完了@%{time_pretransfer}秒経過\n\
対象サーバ側でHTTPコンテンツ生成...\n\
対象サーバ側でHTTPコンテンツ生成完了。HTTPコンテンツを受信開始@%{time_starttransfer}秒目\n\
HTTPコンテンツの受信中...\n\
HTTPコンテンツの受信完了。ここまでにかかった合計時間は%{time_total}秒でした。\n\
" \
2> /dev/null
