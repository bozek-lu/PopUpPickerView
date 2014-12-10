class PopUpPickerView: UIView {
    var pickerView: UIPickerView!
    var pickerToolbar: UIToolbar!
    var toolbarItems: [UIBarItem]!
    
    var delegate: PopUpPickerViewDelegate? {
        didSet {
            pickerView.delegate = delegate
        }
    }
    private var selectedRows: [Int]!
    
    // MARK: Initializer
    override init() {
        super.init()
        initFunc()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        initFunc()
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initFunc()
    }
    private func initFunc() {
        let screenSize = UIScreen.mainScreen().bounds.size
        self.backgroundColor = UIColor.blackColor()
        
        pickerToolbar = UIToolbar()
        pickerView = UIPickerView()
        toolbarItems = []
        
        pickerToolbar.translucent = true
        pickerView.showsSelectionIndicator = true
        pickerView.backgroundColor = UIColor.whiteColor()
        
        self.frame = CGRectMake(0, screenSize.height, screenSize.width, 260)
        pickerToolbar.frame = CGRectMake(0, 0, screenSize.width, 44)
        pickerView.frame = CGRectMake(0, 44, screenSize.width, 216)
        

        let cancelItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "cancelPicker")
        let flexSpaceItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        let doneButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: Selector("endPicker"))
        toolbarItems! += [cancelItem, flexSpaceItem, doneButtonItem]
        
        pickerToolbar.setItems(toolbarItems, animated: false)
        self.addSubview(pickerToolbar)
        self.addSubview(pickerView)
    }
    func showPicker() {
        selectedRows = getSelectedRows()
        let screenSize = UIScreen.mainScreen().bounds.size
        UIView.animateWithDuration(0.2) {
            self.frame = CGRectMake(0, screenSize.height - 260.0, screenSize.width, 260.0)
        }
    }
    func cancelPicker() {
        hidePicker()
        restoreSelectedRows()
    }
    func endPicker() {
        hidePicker()
        delegate?.pickerView(pickerView, didSelect: getSelectedRows())
    }
    private func hidePicker() {
        let screenSize = UIScreen.mainScreen().bounds.size
        UIView.animateWithDuration(0.2) {
            self.frame = CGRectMake(0, screenSize.height, screenSize.width, 260.0)
        }
    }
    private func getSelectedRows() -> [Int] {
        var selectedRows = [Int]()
        for i in 0..<pickerView.numberOfComponents {
            selectedRows.append(pickerView.selectedRowInComponent(i))
        }
        return selectedRows
    }
    private func restoreSelectedRows() {
        for i in 0..<selectedRows.count {
            pickerView.selectRow(selectedRows[i], inComponent: i, animated: false)
        }
    }
}

protocol PopUpPickerViewDelegate: UIPickerViewDelegate {
    func pickerView(pickerView: UIPickerView, didSelect numbers: [Int])
}