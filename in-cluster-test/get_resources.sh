#!/bin/bash

# Kubernetesクラスターの設定ファイルを指定します。
# 通常、設定ファイルは$HOME/.kube/configに保存されていますが、環境によって異なる場合があります。
KUBECONFIG_PATH="$HOME/.kube/config"
KUBECTL_PATH=`which kubectl`

# kubectlコマンドを実行するために、設定ファイルを一時的に設定します。
export KUBECONFIG="$KUBECONFIG_PATH"

# リソースの一覧を取得する関数を定義します。
get_resources() {
    echo "------------------- Nodes -------------------"
    kubectl get nodes --all-namespaces

    echo "------------------- Pods -------------------"
    kubectl get pods --all-namespaces

    echo "----------------- Deployments -----------------"
    kubectl get deployments --all-namespaces

    echo "----------------- Replicasets -----------------"
    kubectl get rs --all-namespaces

    echo "------------------ Services ------------------"
    kubectl get services --all-namespaces

    echo "------------------ Ingress ------------------"
    kubectl get ingress --all-namespaces
}

# ループ間隔を指定します（秒単位）。
LOOP_INTERVAL=1

# 無限ループを開始します。
while true; do
    clear  # 画面をクリアして新しい情報を表示します。
    get_resources  # リソースの一覧を表示します。
    sleep $LOOP_INTERVAL  # 指定した間隔でリフレッシュします。
done

unset KUBECONFIG
