# [1]레지스트리에 저장된 이미지 제거 미리보기
PURGE_CMD="acr purge \
  --filter 'hi-class-api:.*' --filter 'hi-class-ui:.*' \
  --ago 0d --untagged --dry-run"

az acr run \
  --cmd "$PURGE_CMD" \
  --registry hiclass \
  /dev/null

# [0]레지스트리 이미지 제거
# 경로 : /home/sigongweb/work/kube/acr_purge.sh 
PURGE_CMD="acr purge \
  --filter 'hi-class-api:.*' --filter 'hi-class-ui:.*' \
  --ago 0d --untagged"

az acr run \
  --cmd "$PURGE_CMD" \
  --schedule "0 1 * * Sun" \
  --registry hiclass \
  /dev/null
