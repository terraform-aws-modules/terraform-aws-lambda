ID=$(aws deploy create-deployment \
    --application-name my-awesome-app \
    --deployment-config-name CodeDeployDefault.LambdaAllAtOnce \
    --deployment-group-name something \
    --description "My demo deployment" \
    --revision '{"revisionType": "AppSpecContent", "appSpecContent": {"content": "{\"Resources\":[{\"MyFunction\":{\"Properties\":{\"Alias\":\"current-with-refresh1\",\"CurrentVersion\":\"1\",\"Name\":\"fond-mammoth-lambda1\",\"TargetVersion\":\"1\"},\"Type\":\"AWS::Lambda::Function\"}}],\"version\":\"0.0\"}", "sha256": "500fed8354d2a90a8551a0166837e45dbbf6fc6b0d138a5792502d0a0d35e604"}}' \
    --output text \
    --query '[deploymentId]')

STATUS=$(aws deploy get-deployment \
    --deployment-id $ID \
    --output text \
    --query '[deploymentInfo.status]')

while [[ $STATUS == "Created" || $STATUS == "InProgress" || $STATUS == "Pending" || $STATUS == "Queued" || $STATUS == "Ready" ]]; do
    echo "Status: $STATUS..."
    STATUS=$(aws deploy get-deployment \
        --deployment-id $ID \
        --output text \
        --query '[deploymentInfo.status]')
    sleep 5
done

if [[ $STATUS == "Succeeded" ]]; then
    EXITCODE=0
    echo "Deployment finished."
else
    EXITCODE=1
    echo "Deployment failed!"
fi

aws deploy get-deployment --deployment-id $ID
exit $EXITCODE

