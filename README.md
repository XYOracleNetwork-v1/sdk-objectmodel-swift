[logo]: https://www.xy.company/img/home/logo_xy.png

![logo]

# sdk-objectmodel-swift

[![Maintainability](https://api.codeclimate.com/v1/badges/6b78896e372ff59eda66/maintainability)](https://codeclimate.com/repos/5c475d0a09eb2c0286007ee2/maintainability)


Implementation of the [XYO object model](https://github.com/XYOracleNetwork/spec-coreobjectmodel-tex/blob/new-scheme/tex/scheme.pdf) in swift.  

## Getting Started
This library is structed into 4 centrel objects that you may be using, the buffer, the structure, the iterable structure, and the schema. 

### Buffer

The XyoBuffer class is a tool to create byte buffers so you can easily place numbers, schemas, and any other data.

#### Creating a Buffer
You can create a buffer from nothing, from another buffer, or a subset of another buffer.
```swift
let emptyBuffer = XyoBuffer() // creates an empty buffer
let byteFilledBuffer = XyoBuffer(data: [0x13, 0x37]) // creates a buffer with 0x1337 inside of it
let subBufferFromBytes = XyoBuffer(data: [0x00, 0x01, 0x02, 0x03], allowedOffset: 1, lastOffset: 3) // creates a buffer with the value 0x0102
let subBufferFromBuffer = XyoBuffer(data: XyoBuffer(...), allowedOffset: 1, lastOffset: 3) // creates a buffer with from range 1 to 2

```

#### Adding to a Buffer
After a buffer is created, you can append other data to the end of it.
```swift
let buffer = XyoBuffer()
buffer.put(schema: XyoObjectSchema(0, 0)) // puts a schema into the buffer
buffer.put(bytes: [0x13, 0x37]) // puts 0x1337 into the buffer
buffer.put(bits: UInt8(5)) // puts a single byte into the buffer
buffer.put(bits: UInt16(5)) // puts a short into the buffer
buffer.put(bits: UInt32(5)) // puts a int into the buffer
buffer.put(bits: UInt62(5)) // puts a long into the buffer
buffer.put(buffer: XyoBuffer(...)) // puts a buffer into the buffer
```

#### Getting from a Buffer
After a buffer has data in it, you can extract meaningful data from it.
```swift
let schema = buffer.getSchema(offset: 2) // gets a schema at offset 2
let number = buffer.getUInt8(offset: 2) // gets a byte at offset 2
let number = buffer.getUInt16(offset: 2) // gets a short at offset 2
let number = buffer.getUInt32(offset: 2) // gets a int at offset 2
let number = buffer.getUInt64(offset: 2) // gets a long at offset 2
let subBuffer = buffer.copyRangeOf(from: 2, to: 4) // gets a range between 2 and 4
```


### Schema
The XyoSchema struct is an object used to contain information about how a certain object is encoded. A schema is broken down into two bytes, the encoding catalogue and the id. The encoding catalogue includes how large the size is, if it is iterable, if it is a typed iterable, and its id. The id is simply the id of the schema.

#### Creating a Schema
You can create a schema from an encoding catalogue and an id, from config pramaters, or from bytes.

```swift
let manualSchema = XyoObjectSchema(id : 12, encodingCatalogue : 20) // creates a schema with id 12, and encodingCatalogue 20
let configSchema = XyoObjectSchema.create(id : 12, isIterable : true, isTypedIterable: false, sizeIdentifier : XyoObjectSizes.TWO) // create an iteratble untyped schema with id 12, and a two byte size.
```

#### Reading a Schema
After a schema is created, it can be read from to obtain information about the proceding object.
```swift
let id = schema.id // gets the id
let isTyped = schema.getIsTypedIterable() // gets if the schema is typed
let isIterable = schema.getIsIterable() // gets if the schema is iterable
let sizeOfSize = schema.getSizeIdentifier() // gets the size of the size
```

## License
This project is licensed under the MIT License - see the LICENSE.md file for details
