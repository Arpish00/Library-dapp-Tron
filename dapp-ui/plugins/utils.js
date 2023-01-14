//import LibraryABI from './libraryABI'

let account = null
let libraryContract
let libraryContractAddress = 'TD7g2t959bRjm5DFsAHYTwFrhrNLXU3gJ9' // Paste Contract address here
let bookRentContract = null


export const accountAddress = () => {
  return account
}

export function getTronWeb(){
  // Obtain the tronweb object injected by tronLink 
  var obj = setInterval(async ()=>{
    if (window.tronWeb && window.tronWeb.defaultAddress.base58) {
        clearInterval(obj)
        console.log("tronWeb successfully detected!")
    }
  }, 10)
}
 
export async function setLibraryContract () {
  bookRentContract = await window.tronWeb.contract().at('TMH1jAzAjCp2GdWm7hXSmhYyD3iKdpExoZ');
}


export async function postBookInfo(name, description, price) {

const result = await bookRentContract.addBook(name, description, price).send ({
  feeLimit:100_000_000,
  callValue:0,
  shouldPollResponse:true 
});

  alert('Book Posted Successfully')

}

export async function borrowBook(spaceId, checkInDate, checkOutDate, totalPrice) {

  const result = await bookRentContract.borrowBook(spaceId,checkInDate,checkOutDate).send({
    feeLimit:100_000_000,
    callValue:totalPrice,
    shouldPollResponse:true
  });

  alert('Property Booked Successfully')
}


  
//browse book
export async function fetchAllBooks () {
  const books = [];

const bookId = await bookRentContract.bookId().call();

  for ( let i = 0; i < bookId; i++) {
    const book = await bookRentContract.books(i).call()
    //filter book
    if(book.name != "") {
      books.push(
        {id: i, name: book.name, description: book.description, price: tronWeb.fromSun(book.price)}
      )
    }
  }
  return books
}




