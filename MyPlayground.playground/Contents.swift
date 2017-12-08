import Foundation
import IDZSwiftCommonCrypto

let tmp = NSTemporaryDirectory() as NSString
let encryptedFilePath = Bundle.main.path(forResource: "encrypted", ofType: "pdfenc")
var decryptedFilePath = "\(tmp)test.pdf"

var encryptedFileInputStream = InputStream(fileAtPath: encryptedFilePath)!
var decryptedFileOutputStream = OutputStream(toFileAtPath: decryptedFilePath, append:false)!

let keyK = "4c7b3180a4dca6ece2d051811a7b9ca23f210e28ceabd92c5d171e567875f70b"
let tkeyK = arrayFrom(hexString: keyK)

let iv = Array<UInt8>()
let bufferSize = 1024
let sc = StreamCryptor(operation: StreamCryptor.Operation.decrypt, algorithm: StreamCryptor.Algorithm.aes, mode: StreamCryptor.Mode.CTR, padding: StreamCryptor.Padding.NoPadding, key: tkeyK, iv: iv)


var inputBuffer = Array<UInt8>(repeating:0, count:1024)
var outputBuffer = Array<UInt8>(repeating:0, count:1024)
encryptedFileInputStream.open()
decryptedFileOutputStream.open()

var cryptedBytes : Int = 0

while encryptedFileInputStream.hasBytesAvailable {
	let bytesRead = encryptedFileInputStream.read(&inputBuffer, maxLength: inputBuffer.count)
	let status = sc.update(bufferIn: inputBuffer, byteCountIn: bytesRead, bufferOut: &outputBuffer, byteCapacityOut: outputBuffer.count, byteCountOut: &cryptedBytes)
	assert(status == Status.success)
	if(cryptedBytes > 0) {
		let bytesWritten = decryptedFileOutputStream.write(outputBuffer, maxLength: Int(cryptedBytes))
		assert(bytesWritten == Int(cryptedBytes))
	}
}

let status = sc.final(bufferOut: &outputBuffer, byteCapacityOut: outputBuffer.count, byteCountOut: &cryptedBytes)
assert(status == Status.success)
if(cryptedBytes > 0) {
	let bytesWritten = decryptedFileOutputStream.write(outputBuffer, maxLength: Int(cryptedBytes))
	assert(bytesWritten == Int(cryptedBytes))
}

encryptedFileInputStream.close()
decryptedFileOutputStream.close()

