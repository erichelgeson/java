# the right version of java is installed
describe command('java -version 2>&1') do
  its('stdout') { should match (/1\.6\.0/) }
end

# env is properly setup
describe os_env('JAVA_HOME') do
  its('content') { should match (/java-1\.6\.0/) }
end

unless os.bsd?
  # alternatives were properly set
  describe command('alternatives --display jar') do
    its('stdout') { should match (/java-1\.6\.0/) }
  end
end

# jce is setup properly
describe command('java -jar /tmp/UnlimitedSupportJCETest.jar') do
  its('stdout') { should match (/isUnlimitedSupported=TRUE, strength: 2147483647/) }
end

# the cert was installed into the keystore
describe command('$JAVA_HOME/bin/keytool -list -storepass changeit -keystore $JAVA_HOME/jre/lib/security/cacerts -alias java_certificate_test') do
  its('stdout') { should match (/9D:9E:EA:E6:5F:D2:C8:34:93:6E:5C:65:EE:00:46:A9:CD:E4:F1:83/) }
end