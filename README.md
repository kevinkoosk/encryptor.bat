# encryptor.bat

## Introduction
Encryptor.bat is a batch file for encrypting ASCII text using an ASCII text key.

This batch script encrypts and decrypts text using a key via XOR encryption.

The encrypted result is in hexadecimal format to handle non-printable characters.

## Usage

### Encrypt

*encryptor.bat encrypt "YourSecretMessage" "MyKey"*

Outputs an encrypted hexadecimal string.

### Decrypt

*encryptor.bat decrypt "EncryptedHexString" "MyKey"*

Outputs the original message.

### Features

- Uses XOR encryption for reversibility.
- Handles special characters via hexadecimal encoding.
- Same key is used for both encryption and decryption.

### Notes

- Ensure the key is the same for both operations.
- Temporary VBScript files are created and deleted automatically.
- May not handle Unicode characters beyond standard ASCII.
- Created using DeepSeek R1
