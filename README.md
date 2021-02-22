# seccom
Secure Com - Simple Chat with symmetric encryption by GnuPG meant to be used via SSH - Passphrase = Chatroom, currently only in German. 

The idead is to use well known tools and a minimalistic code base to implement a chatroom system based solely on symmetric crypto (AES-256)
A key or in this case a chatroom is communicated on a seperate, secure channel. The messages will be encrypted using this chatroom ID / Key.
The program is ment to be used in a chroot or sandboxed enviroment that may be accessed via SSH, which also enables a way to do secure authentication via asymmetric crypto (SSH pubkey)

Todo: 

- build sshfs-based client to enable client-side encryption for untrusted servers
- check and refine key-storage
- translate
