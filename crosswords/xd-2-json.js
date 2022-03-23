const fs = require('fs')
const path = require("path")

const xdparser = require('xd-crossword-parser')

const getAllFiles = (dirPath, arrayOfFiles) => {
  let files = fs.readdirSync(dirPath)

  arrayOfFiles = arrayOfFiles || []

  files.forEach(function(file) {
    if (fs.statSync(dirPath + "/" + file).isDirectory()) {
      arrayOfFiles = getAllFiles(dirPath + "/" + file, arrayOfFiles)
    } else {
      arrayOfFiles.push(path.join(__dirname, dirPath, "/", file))
    }
  })

  return arrayOfFiles
}

getAllFiles('./xd')
  // Get only .xd files
  .filter((filepath) => filepath.endsWith('.xd'))
  // Get the path, name, and contents
  .map((filepath) => ({
    dirpath: path.dirname(filepath),
    filename: path.basename(filepath),
    data: fs.readFileSync(filepath).toString()
  }))
  // Convert to json equivalents
  .map(({ dirpath, filename, data }) => {
    let jsonData = null

    try {
      jsonData = xdparser(data)
      console.log(`[ OK] ${filename}`)
    } catch (error) {
      console.error(`[NOK] ${filename}`)
    }

    return {
      dirpath: dirpath.replace(/\/xd\//, '/json/'),
      filename: filename.replace(/\.xd$/, '.json'),
      data: jsonData
    }
  })
  // Check data is ok
  .filter(({ data }) => data != null)
  // Write json files
  .forEach(({ dirpath, filename, data }) => {
    fs.mkdirSync(dirpath, { recursive: true })
    fs.writeFileSync(path.join(dirpath, filename), JSON.stringify(data))
  })
