FROM debian:latest

LABEL MAINTAINER Richard Lochner, Clone Research Corp. <lochner@clone1.com> \
      org.label-schema.name = "secure-boot" \
      org.label-schema.description = "Secure Boot Tools" \
      org.label-schema.vendor = "Clone Research Corp" \
      org.label-schema.usage = "https://github.com/lochnerr/secure-boot" \
      org.label-schema.vcs-url = "https://github.com/lochnerr/secure-boot.git"

# Manditory packages:
# curl - required by get-ms-certs
# sbsigntool - sbsiglist required by get-ms-certs
# openssl - required by generate-keys
# efitools - cert-to-efi-sig-list and sign-efi-sig-list required by generate-keys
# efivar - required by generate-keys
# uuid-runtime - uuidgen required by generate-keys
# efitools - efi-updatevar required by enroll-efivars
# git - required by create-aws-efi-blob
# python3-venv - required by create-aws-efi-blob

RUN true && \
  apt-get -y update && \
  DEBIAN_FRONTEND=noninteractive apt-get -y install \
	curl \
	sbsigntool \
	openssl \
	efitools \
	efivar \
	uuid-runtime \
	efitools \
	git \
	python3-venv && \
	cd \root && \
	git clone https://github.com/awslabs/python-uefivars && \
	python3 -m venv ~/py_envs && \
	. ~/py_envs/bin/activate && \
	python3 -m pip install google-crc32c && \
	ln -s ~/python-uefivars/uefivars /usr/local/bin && \
	uefivars --help && \
	echo "Done!"

# Copy default Microsoft certificates to use as a baseline.
COPY ms /root/ms

# Copy the script files and other artifacts.
COPY bin/. /usr/local/bin/

