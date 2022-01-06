sudo mkdir -p /mnt/openshift-pv/pv1
sudo chmod g+w -R /mnt/openshift-pv
sudo oc apply -f nano storage.yaml
sudo oc get pv
